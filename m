Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXFYNip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXFYNip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXFYNii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:38:38 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:14010 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbXFYNih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SQME/MAL9C745EAUd4RCAR9kz7KW9OMNr9V3neuPbQF5BZpZiHmiEDeonAd4WzadAz1oySEGfWIpuajstF7ctIzRnGV2RD0wYGUvNo7m8oTyCeeH+p8+nE809jgyzYobhk9Lphv0ZG8uhZeibZh4PP4Ssxj7gu2kG3IFEiF0yfg=
Message-ID: <961aa3350706250638g19940e8bgee254be077c5899@mail.gmail.com>
Date: Mon, 25 Jun 2007 22:38:36 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Andrew A. Razdolsky" <rand@kipt.kharkov.ua>
Subject: Re: Oops: 2.6.21.3 via_rhine
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <467FB58B.2060106@kipt.kharkov.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467FB58B.2060106@kipt.kharkov.ua>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/25, Andrew A. Razdolsky <rand@kipt.kharkov.ua>:
>
> wapper: page allocation failure. order:1, mode:0x20

This is a page alllocation failure, not Oops.
Did you get any problem after getting this message?
