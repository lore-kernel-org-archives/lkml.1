Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZCYCPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZCYCPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZCYCPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:15:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:28140 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbZCYCPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sX1fUcHvxWMDcOYf5IqUoOjXVm7kpHti3VPvMjzYDtDAI8X4PBWTPMYvk9wRAGhqFM
         tmJtSxqzNFlRBPfy2lpOM2Wphwi0+/Nb8fTrW2/FvuEFscGSD3xlgGd/d9YN+WiWkGMR
         wwFF5WB6hynlr0sWspY9s/nwfv282KuP8DZs4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903231106060.4871@axis700.grange>
References: <Pine.LNX.4.64.0903130837040.4653@axis700.grange>
	 <e9c3a7c20903161459n8ad3c6qd705d146703b28a1@mail.gmail.com>
	 <Pine.LNX.4.64.0903231106060.4871@axis700.grange>
Date: Tue, 24 Mar 2009 19:15:35 -0700
X-Google-Sender-Auth: e1d35b12c91f9cd2
Message-ID: <e9c3a7c20903241915v59b41b22x74ca6dd1cd066340@mail.gmail.com>
Subject: Re: [PATCH 0/3 v2] ipu_idmac: code clean-up and robustness 
	improvements
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 3:10 AM, Guennadi Liakhovetski <lg@denx.de> wrote:
> Ok, now split.

Applied, thanks.

--
Dan
