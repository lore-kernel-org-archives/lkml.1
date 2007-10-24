Return-Path: <linux-kernel-owner+w=401wt.eu-S1764962AbXJXRLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764962AbXJXRLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbXJXRLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:11:00 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:5638 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbXJXRK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:10:59 -0400
Message-Id: <471C8572.3C0A.0073.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 24 Oct 2007 11:10:50 -0600
From: "Adam Jerome" <abj@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at  6:55 AM, Adrian Bunk <bunk@kernel.org> wrote: 
> On Wed, Oct 24, 2007 at 12:50:29PM +0100, Simon Arlott wrote:
>> I currently have an LSM that only handles permissions for socket_bind
>> and socket_listen, I load it and then "capability" as secondary on
>> boot - but now I can't because the LSM framework is now just the LS
>> framework.
>> 
>> Why can't this "static LSM" change be a Kconfig option?
>> (I don't want to have to maintain my own reverted copy of security/,
>> or compile this into the kernel because then I can't ever modify and
>> reload it without rebooting.)
> 
> Let's start with the more important questions:
> 
> Did you submit your LSM for inclusion into the kernel?
> 
> If yes, why wasn't it accepted?
> If no, why not?

Those are important questions, no doubt.  However, that does not
address Simon's question.  Especially in light of Linus' statement:

 "I'm also perfectly willing to unapply it if there actually are
  valid out-of-tree users that people push for not merging."

It seems that, whether submitted (and or accepted) into the kernel
or not, Simon has the obligation to respond to Linus' challenge.

-adam



