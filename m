Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXIHWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXIHWz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 18:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXIHWzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 18:55:19 -0400
Received: from mail99.megamailservers.com ([216.251.36.99]:45449 "EHLO
	mail99.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbXIHWzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 18:55:18 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: Re: broken ACPI NUMA config option
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1189291899.13467.20.camel@Tachyon.home>
References: <1189291899.13467.20.camel@Tachyon.home>
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sat, 08 Sep 2007 18:54:36 -0400
Message-Id: <1189292076.13467.23.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-09 at 18:51 -0400, James C. Georgas wrote:
> Steps to reproduce:
> 
> 	make clean
> 	make mrproper
> 	make noallconfig

Excuse me; that should read allnoconfig, not noallconfig.

James
	/\V

