Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149Ab0ALQTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0ALQTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118Ab0ALQTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:19:51 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:46675 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab0ALQTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:19:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AAVO2CEW0xzEYrvin+1CFMdtAvuiy9jO1MKTViM4GOXpSxtB/hwcdB0AWJHMBBMhG+
         1KqrkuNtYfy4+dGBSeYwtEKY3YHPHhltD6aXWciMq+4pwmJr8XzVeyiZPi64fuG6QMma
         xSw+KEK8gAA3zfmHkAKngs7mEzi5CfYIJYqFI=
MIME-Version: 1.0
Date: Tue, 12 Jan 2010 17:19:48 +0100
Message-ID: <1dec3f771001120819x2e9cad5dxf110952cc1347b92@mail.gmail.com>
Subject: dlopen in kernel mode
From: mojtaba <kernelppc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please cc kernelppc@gmail.com]
Dear all,

Are there any alternatives for dlopen(), dlsym() and dlclose() in
kernel mode? Basicly, I need to load an executable object file  and
execute an specific function in it.

Best regards,
moji
