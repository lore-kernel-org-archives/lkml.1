Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbXKBQFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbXKBQFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbXKBQFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:05:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:42458 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbXKBQFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=J2yXF/oiR+hqG4PxEMCW4/3mQnqT0bSf+OcWsOUjANMqVG+kNqTOr1b8zOSP6at5Kwueqd5V0ixI3Dq289swTssnjhGu9tNbiIXptWjrFdkhwOssrk4CFK/BaCKBLc81e/47TCBdm8t5xtdNW8FSdC80ipBiCQA8ZlB7J0ClH1k=
Message-ID: <3d8471ca0711020905p6dc685edv2818bc15ac4c02b2@mail.gmail.com>
Date: Fri, 2 Nov 2007 17:05:31 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] Fix delay accounting regression
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071102155358.GA32116@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071102142220.24166.49046.sendpatchset@balbir-laptop>
	 <20071102155358.GA32116@elte.hu>
X-Google-Sender-Auth: e15b78e8625e7e75
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Ingo Molnar <mingo@elte.hu> wrote:

> What user-space tools are utilizing delay-accounting by the way?

Thanks for the plugging opportunity ;-)
http://guichaz.free.fr/misc/#iotop uses the I/O side of delay-accounting.

-- 
Guillaume
