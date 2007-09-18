Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbXIRP1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbXIRP1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbXIRP1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:27:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:7950 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbXIRP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QlUwC9BfVNJniBhWroI2uD1H7FppF/Cpicai75SdsYlTp9E91L+prhzn+LPPqll9eMYROYECmSjVHdnKhja5zl8pBcyw8sO9f2sqXpyKDApaDN23mr5pi55D0m5KxF64EVAv0gU/iZix2NJY6zeWJovfRTnOm3oVXS+zPHBiTuY=
Message-ID: <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com>
Date: Tue, 18 Sep 2007 11:27:23 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc6-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Selecting Help for "Subarchitecture Type" causes "make menuconfig" to
crash, and the bash display settings have to be reset.

       Miles
