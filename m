Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXIYHJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXIYHJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbXIYHJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:09:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:14965 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbXIYHJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MAUy400MqZDxVx03jTmzEGskzpNFMpF6k5i6jjYRa7hg/fLKDjYqXNyZiDV8Cgy7MDu1HZHaRtP1JWyPrBROhOJn7FmwQWqac3oKfdfrcD+neQzOsOoil4dk4kL2M0chf7a4+wj/TYvOGYHrnTazPJhrauYFjAFIWvzF6gaJFyY=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
Date: Tue, 25 Sep 2007 10:09:29 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200709220828.00078.mihai.dontu@gmail.com> <20070924144344.GA14022@alberich.amd.com>
In-Reply-To: <20070924144344.GA14022@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709251009.30081.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007, Andreas Herrmann wrote:
> Have you tried to boot your kernel with
> 
>    video=radeonfb:noaccel
> 
> I usual add this kernel parameter when running radeonfb and X.
> 
> Otherwise I've observed the same symptoms (e.g. with my radeon card
> at home: Radeon X300SE, 1002:5b70).

It works. Golden option. Should be documented somewhere.

Thanks,

-- 
Mihai Donțu
