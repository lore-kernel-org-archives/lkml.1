Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbZLVL1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbZLVL1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZLVL1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:27:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49399 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZLVL1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:27:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LbC0FzSkMiPtp6iAHAyjluBchCzkbAhyTxVChube7cJE4qZokkJaz/A77tSsJgjcQk
         xXeJOat+zdaOCPmU1T6hCiRwEpVs4HbovCPi1i7AQGRPojVTofj7bp/r1wTvw4uIvztp
         Qqem4NV1GVyzFoqfwu4Jdl3eoRo6prK1rF4dE=
MIME-Version: 1.0
Date: Tue, 22 Dec 2009 19:27:09 +0800
Message-ID: <df5e30c50912220327o68d9d04al680aa7fbdd3e32f1@mail.gmail.com>
Subject: Question: sRIO static ID allocation without enumeration
From: Jian Wang <dominicwj@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one question about the RapidIO. The current Linux freescale MPC85xx
driver fsl_rio.c enumerates the sRIO network and allocate device IDs to its
link partners, but I want to statically assign device IDs to the sRIO
devices in the sRIO topology. How could I do this to stop the driver from
enumerating the network? Thanks a lot!

BR/Dominic
