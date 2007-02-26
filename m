Return-Path: <linux-kernel-owner+w=401wt.eu-S1161384AbXBZXD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161384AbXBZXD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161386AbXBZXD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:03:58 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:63582 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161384AbXBZXD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:03:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IAaRyARwFPZ4TzlCQkHUVek3f+u48H2I1W+GtmPP/ZCo58nE+au1PuNerLuTwufoc9y5emoSPeT4x3RpX6a/Xy53R3hgebjbz+vpMjv7R9az1AinYwXuUF4qE61LJOsos6EGDG4TK2ZccSnzMIb1iVg8BYo9s/xd2E5YUGwMBLA=
Message-ID: <abe01d5c0702261503p3212d7dcg925588bb325a4460@mail.gmail.com>
Date: Mon, 26 Feb 2007 20:03:55 -0300
From: "Fausto Carvalho" <faustocarva@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Using serio_register_driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a driver that have to coexist with ATKBD accessing the same
i8042 platform driver. But when a use serio_register_driver and
program the serio_driver.interrupt i only get the atkbd to respond!!
Is there any way to use ATKBD with another i8042 driver( serio)??
Any help is wellcome.

-- 
Fausto Carvalho
