Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYGYUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYGYUrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYGYUrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:47:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:63320 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYGYUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=sGR7+naXlA+WIDLeQUcCIsZH+98pc/3tHFCiv+qaU8ZdcoDgmgcABzKPgZB1Pclz0w
         LovK24gNadUGEZ6aKgtwGdppGIm0T8sCI7bJIuMetgo8s9SLUetjcpnT7mvj81Xw6OKT
         DTWKvg9+3zkm6d3SwGhnsnmBDh8/bsCd9L5oM=
Message-ID: <86802c440807251347x424b14d4j663928922a507d9a@mail.gmail.com>
Date: Fri, 25 Jul 2008 13:47:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>, "Ayaz Abdulla" <aabdulla@nvidia.com>
Subject: forcedeth mac reversed again via kexec
Cc: nedev <netdev@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mac address ordering get reversed again by kexec path in second kernel
in current linus tree
it is ck804 system

YH
