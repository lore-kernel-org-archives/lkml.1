Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbXEOIXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbXEOIXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbXEOIXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:23:47 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:11634 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbXEOIXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JoHw4EZOkwGWO09HHH1WXM6VPs74KN/zfocN9uoSPdY44UKkRXtGJTuBJCyumkvLcpgCD0JBaRq0Gc9/up1FubJHQm3MG9zxOSF8I7VZfaNVPl5pKwxQpj9Yk8BL3wNiSgTvjRfe/rIN8b8dghI8PPogvm1Hz3/lI7vs+l5VrnY=
Message-ID: <b2981f030705150123i286b61dape5c3de9cc170d9e0@mail.gmail.com>
Date: Tue, 15 May 2007 13:53:45 +0530
From: "S K" <kernelandme@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Masking console output at boot time
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -
I want to mask all the messsages that are printed on console at boot
time. I am looking for an approach, in which we can print '#' for
every line of output sent to console at boot time.

Can anybody suggest me something in this regard.

TIA
/)andeep
