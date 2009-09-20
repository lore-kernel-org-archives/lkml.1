Return-Path: <linux-kernel-owner+w=401wt.eu-S1752124AbZITGDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbZITGDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 02:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZITGDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 02:03:14 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:42205 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZITGDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 02:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kWbyV6LvW4y6J/i/RNQBz7BTGnfAc+/G1X6IPJQJeTfpBdawvACr4Cd+taFolLElSa
         6acOk82FjWxOleKRbbme6lBagHXDhV3nCUsuVd8QM+hQVnEJF1kyghVOwobqjl3kPVpV
         KBNTBf7LNyQqGBeSlaxogTOUBZINn+yyFFkUo=
MIME-Version: 1.0
In-Reply-To: <200909192211.12226.volkerarmin@googlemail.com>
References: <200908211814.56800.volkerarmin@googlemail.com>
	 <200908270313.32528.volkerarmin@googlemail.com>
	 <86802c440908270013k4b8c75b1h6bac33a623ded5e7@mail.gmail.com>
	 <200909192211.12226.volkerarmin@googlemail.com>
Date: Sat, 19 Sep 2009 23:03:13 -0700
Message-ID: <86802c440909192303j643d83b5te710926a99ddb2e5@mail.gmail.com>
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and 
	earlier.
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

your looks ok, because you got new CPU, and HW will set WB for [4G, TOM2)

YH
