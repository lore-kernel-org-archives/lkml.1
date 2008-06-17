Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYFQUXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYFQUXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 16:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYFQUX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 16:23:27 -0400
Received: from lazybastard.de ([212.112.238.170]:59882 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYFQUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 16:23:26 -0400
Date: Tue, 17 Jun 2008 22:23:19 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the kernel
Message-ID: <20080617202318.GC31224@logfs.org>
References: <48580116.9070504@am.sony.com> <20080617190750.GA31224@logfs.org> <485815F6.20507@am.sony.com> <485816B3.3080800@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <485816B3.3080800@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 June 2008 12:55:31 -0700, Tim Bird wrote:
> 
> Sorry - I responded too quickly.  I'm not sure I follow the
> original suggestion.  How would I call the open function of
> a module that is not initialized yet?

Hmm, good point.  I guess that suggestion has just failed the reality
test.

Jörn

-- 
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace
