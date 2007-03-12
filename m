Return-Path: <linux-kernel-owner+w=401wt.eu-S1030258AbXCLPIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258AbXCLPIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030361AbXCLPIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:08:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51539 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030258AbXCLPIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:08:52 -0400
Date: Mon, 12 Mar 2007 20:45:48 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: ckrm-tech@lists.sourceforge.net, xemul@sw.ru, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       menage@google.com, Herbert Poetzl <herbert@13thfloor.at>,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070312151548.GC24742@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <45EF5A62.8000103@vilain.net> <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com> <45EF5E71.7090101@vilain.net> <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com> <m1d53ka5b9.fsf@ebiederm.dsl.xmission.com> <20070309005357.GC4506@MAIL.13thfloor.at> <20070309181908.GC21661@in.ibm.com> <20070309215218.GA17592@MAIL.13thfloor.at> <20070309140603.b2b162c6.pj@sgi.com> <20070312140148.GA10450@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312140148.GA10450@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 07:31:48PM +0530, Srivatsa Vaddagiri wrote:
> not so. This in-fact lets vservers and containers to work with each
> other. So:

s/containers/cpusets

-- 
Regards,
vatsa
