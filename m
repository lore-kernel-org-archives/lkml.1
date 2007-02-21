Return-Path: <linux-kernel-owner+w=401wt.eu-S1751223AbXBULzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbXBULzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXBULzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:55:53 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:48080 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbXBULzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:55:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hwdHMbxKpb29yM4FE8YTaCNRBmjnGb4MwtpYRk01ldkUWv7n13J1YdA4Xm3cQaJEmVEXWhEHgrN3ZyJQ07k4qe5OcB3HjK4FSX0gfsb0+r9bKXZQVCbnWpfLVmizd8iZ7jsjQTfWFqbmmx9zmX+z0z79/RkHZ8JwfAJdPOQFOhI=
Message-ID: <45DC3345.5000804@gmail.com>
Date: Wed, 21 Feb 2007 20:55:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Manuel Metz <mmetz@astro.uni-bonn.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA ahci Bug in 2.6.19.x
References: <7G2pJ-2iX-23@gated-at.bofh.it> <7G828-3zn-3@gated-at.bofh.it> <7HpWX-3D2-5@gated-at.bofh.it> <7Hrci-5ou-5@gated-at.bofh.it> <7HrP4-6t8-1@gated-at.bofh.it> <7Hvzs-3Tj-23@gated-at.bofh.it> <7IYJ1-281-27@gated-at.bofh.it> <45D2CEFC.4010900@astro.uni-bonn.de>
In-Reply-To: <45D2CEFC.4010900@astro.uni-bonn.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does it work if you give 'irqpoll' kernel parameter?

-- 
tejun
