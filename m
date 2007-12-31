Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbXLaQRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbXLaQRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXLaQRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:17:24 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40050 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbXLaQRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:17:21 -0500
Date: Mon, 31 Dec 2007 10:17:21 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: TOMOYO Linux Security Goal
Message-ID: <20071231161721.GA29992@sergelap.austin.ibm.com>
References: <20071227145431.GB5161@sergelap.austin.ibm.com> <200712282332.EGC57888.OFFQHJOLVSMtFO@I-love.SAKURA.ne.jp> <20071228151221.GA12548@sergelap.austin.ibm.com> <200712291243.HFE05726.MFOJOVLQFFOtSH@I-love.SAKURA.ne.jp> <20071231151712.GA28624@sergelap.austin.ibm.com> <200801010025.DDC48911.SOLOMQFFHVFtOJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801010025.DDC48911.SOLOMQFFHVFtOJ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> Hello.
> 
> Serge E. Hallyn wrote:
> > > Does a process get different mount trees by just calling clone() or unshare()?
> > > My understanding is that clone() or unshare() disables propergation of
> > > mount tree changes when somebody calls mount() or umount() or pivot_root().
> > 
> > Yes, with further propagation rules possible.
> > 
> Excuse me. To which statement did you say "yes"?

Sorry, "yes your understanding was correct."

> Does clone() or unshare() change visible directories without
> calling following mount()/umount()/pivot_root()?
> 
> Regards.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
