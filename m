Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXCUOuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXCUOuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXCUOuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:50:10 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:7912 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbXCUOuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:50:07 -0400
Message-ID: <46014616.3050304@sciensis.com>
Date: Wed, 21 Mar 2007 16:49:58 +0200
From: Tasos Parisinos <t.parisinos@sciensis.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
Cc: Francois Romieu <romieu@fr.zoreil.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel  
              version 2.6.20.1)
References: <45FEB8B7.7020200@sciensis.com>    <20070320004001.GA11601@electric-eye.fr.zoreil.com>    <000601c76af9$a0ce3ce0$0864a8c0@scs1>    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>    <000e01c76b99$769cbbe0$0864a8c0@scs1>    <3118.81.207.0.53.1174480598.squirrel@secure.samage.net>    <46012E1A.3030309@sciensis.com> <1860.81.207.0.53.1174485549.squirrel@secure.samage.net>
In-Reply-To: <1860.81.207.0.53.1174485549.squirrel@secure.samage.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

on the previous message the exponent is not 32 bits but 64 bits, sorry
