Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZBJLjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZBJLjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZBJLjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:39:44 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:40170 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZBJLjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=QjYHjRCCndOf4d+Yk7OGyxDYR6mJj7/Gl3bgY9hVhbL3V+mtnY7kuZQ+L5fCpSM29M
         RwNcWs1HAVsyCZmoqcLMwiW6CM2Jwi3f8ui/vmYk8um2Sj6EnhszFUMsPldSeOmOYfpv
         JnfHawDORcEtQNhl04a1tZWXc+Zk4Z3zH9TfE=
Date: Tue, 10 Feb 2009 11:39:35 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Ira Snyder <iws@ovro.caltech.edu>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Dai Haruki <dai.haruki@freescale.com>,
       Andy Fleming <afleming@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH net] gianfar: Fix boot hangs while bringing up gianfar
	ethernet
Message-ID: <20090210113935.GA14808@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209193440.GA2537@ami.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-02-2009 20:34, Jarek Poplawski wrote:
...
> PS: Ira, your mta config is a bit unusual here wrt. reply; I hope you
> will forgive me adding you to CC anyway.

FYI, AFAIR long time ago Ingo Molnar asked me to turn off this nice
feature called in mutt "followup_to". But, of course, if you find it
useful for you, then forget it.

Cheers,
Jarek P. 
