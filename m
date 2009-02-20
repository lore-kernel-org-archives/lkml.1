Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZBTGKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZBTGKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 01:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZBTGJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 01:09:59 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:62394 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZBTGJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 01:09:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=b3uv3c6T89zXRY12Uao/o9cmK/7C3gIRTV9Zs57akXiwIhy8fn/P+phWCsbGur1fIF
         zLffvbph3//y3cMLCLkiwmQ0c2vJY/6u0HSTR85agdcIIiQzd2xDGsnqTo0W2WREbG75
         UeUcWcBkfzcRHtwHYcDV+P19CvXeKxF7rvSqs=
MIME-Version: 1.0
Date: Fri, 20 Feb 2009 11:39:57 +0530
Message-ID: <aecf5e530902192209o37eea15djd24adfeaf84ca0b0@mail.gmail.com>
Subject: I2C query regarding baud rate
From: Sasa Sasa <sasak.1983@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm@vger.kernel.org
Cc: khali@linux-fr.org, marc.pignat@hevs.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a query regarding the baud rate of I2C controller. Our I2C
controller supports 3 different baud rates. So is there any possible
or standard way for I2C clients to set this baud rate on I2C adaptor
dynamically?


Regards
Sasa
