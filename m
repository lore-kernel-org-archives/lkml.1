Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbYEED5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbYEED5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 23:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYEED5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 23:57:40 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:25766 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYEED5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 23:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=f3hSvxYDhTwtGcrmSSQ0yiTiYCuYhuD1qQ1I54ZyvR5FXo2AsHkN65/0GYynwQcS9K+sduyv85Em5C0+jF3ltHb895VwfLtk36LEefR2iiwozUvW7pi4xNl7qc59O4gZbaKOr+bH1dqaal181AwHAqbFlbEI+5N2AQp6bqE4FPg=
Date: Sun, 4 May 2008 23:57:33 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Takashi Iwai <tiwai@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch][resend] pcspkr: fix dependancies
Message-ID: <20080505035733.GA11584@anvil.corenet.prv>
References: <481D3A08.2040500@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481D3A08.2040500@aknet.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 08:22:32AM +0400, Stas Sergeev wrote:
> Thomas Gleixner wrote:
> > The input changes need to go via Dimitry, the x86 part can go in the
> > same commit.
> > Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Dmitry, would you mind applying this one?
> If not, then I see no way to get either
> fix applied...
> 

Ok, but don't you need to also add the same dependancy for SND_PCSP?

-- 
Dmitry
