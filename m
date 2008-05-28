Return-Path: <linux-kernel-owner+w=401wt.eu-S1751231AbYE1Ndr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbYE1Ndr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYE1Ndd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:33:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:51602 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYE1Ndc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uqG2Dqcv/Ww++PvrqNYBeJF+WznSvd4gvCHQOf30sF/L5VqzZ8WuZfLBUbC/wMmgy/2DIhu1goBFICq2oUFyjCuY9cJ0nulKoXFWNjeRUAnCKfH1NERsCGoWnVL3MnERerM5/zNGu1gFi5/wOEpRsekj5tI0Ps7/2YMMcqifo10=
Message-ID: <2f11576a0805280633p2be93911n3050c11861c1ebb@mail.gmail.com>
Date: Wed, 28 May 2008 22:33:26 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH -mm 00/16] VM pageout scalability improvements (V8)
Cc: "Rik van Riel" <riel@redhat.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>
In-Reply-To: <483D46CE.2020507@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523195506.084894989@redhat.com>
	 <483B0077.7000207@linux.vnet.ibm.com>
	 <20080526153318.29edc0b2@bree.surriel.com>
	 <483D46CE.2020507@linux.vnet.ibm.com>
X-Google-Sender-Auth: 1d8065a6945f499c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi balir-san,

> I've run into a case where with the splitvm patches the memory controller
> immediately OOMs a task in the cgroup on exceeding it's limit. I am going to try
> and find the root cause for it.

I sent the patch of fix this problem.
please see it.
