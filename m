Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYKJR5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYKJR5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYKJR5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:57:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400AbYKJR5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:57:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Mathieu Chouquet-Stringer" <mchouque@free.fr>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Date: Mon, 10 Nov 2008 19:02:19 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20081109195033.GA1335@mobydick> <200811092059.31178.rjw@sisk.pl> <20081109203737.GA2056@mobydick>
In-Reply-To: <20081109203737.GA2056@mobydick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811101902.19855.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of November 2008, Mathieu Chouquet-Stringer wrote:
> On Sun, Nov 09, 2008 at 08:59:30PM +0100, Rafael J. Wysocki wrote:
> > Please check if that's http://bugzilla.kernel.org/show_bug.cgi?id=11989 and
> > if that's the case, please add a "me too" to the bug entry.
> 
> Thanks for the quick reply, sadly I don't have CONFIG_STOP_MACHINE
> defined so that's not it...

Well, nothig obvious comes to mind.

Please check 2.6.27 and if that works, can you please bisect?

Rafael
