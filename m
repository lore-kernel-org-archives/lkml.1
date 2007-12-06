Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXLFMWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXLFMWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbXLFMVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:21:55 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:32272 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbXLFMVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:21:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VqPGgYGP+VBVzKt16JaM3elOCCpn6d0Ny6ZGMTqtyj6NPc7YWRjkk8iMoEpALss1oBRPQnzpGHCliTQFq6ArTMq1O3Cz5ZcjQi3DV8lC1vr8knnJ67nDK2jRUbWChzvjSKW6MQfQQUnH9w+mm+5hWPUOcWzPiVvMD4oF23a8mpk=
Message-ID: <c384c5ea0712060421t24898ae6gb633a6b916f9cfa7@mail.gmail.com>
Date: Thu, 6 Dec 2007 13:21:52 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Jaursch, Bill" <bjaursch@aeshen.com>
Subject: Re: FW: Guidance on resources for User Space Device Drivers on 2.6 kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <32A49E5BEBD67A4F877032926EFAA4D209283BD7@ms08.mse3.exchange.ms>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <32A49E5BEBD67A4F877032926EFAA4D209283BD7@ms08.mse3.exchange.ms>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you have any other suggestions on projects, articles, etc. on Linux User Space Device Drivers, I would greatly appreciate the information.
>

A suggestion:

UIO: user-space drivers, since kernel version 2.6.21

http://lwn.net/Articles/232575/

Regards,
--
Leon
