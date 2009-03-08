Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZCHXVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZCHXVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 19:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZCHXVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 19:21:30 -0400
Received: from main.gmane.org ([80.91.229.2]:43402 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZCHXVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 19:21:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: [PATCH] Re: ALSA HDA Intel stoped to work in 2.6.16-*
Date: Sun, 8 Mar 2009 23:21:13 +0000 (UTC)
Message-ID: <loom.20090308T231221-216@post.gmane.org>
References: <87wtfhx7rm.fsf@nurf.casa> <s5hek1fmzf4.wl%tiwai@suse.de> <gou8k9$reh$1@ger.gmane.org> <200903071900.44762.rjw@sisk.pl> <s5h63ikjool.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 66.218.54.163 (Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.0.6) Gecko/2009011913 Firefox/3.0.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai <at> suse.de> writes:

> Daniel, how "incorrect" do you mean exactly?
> 
> As you cited, the above patch was added for the request for the
> specific model, so the patch itself is correct per definition.  What
> wrong could be the choice of the model option by the original poster,
> which I cannot judge.
> 
> Of course I have no objection to fix the model entry at all, but I
> need a more proper justification.

The master volume control appeared to be affecting the wrong control line, and
there was no way to turn off IEC958, which appeared to be on by default.

