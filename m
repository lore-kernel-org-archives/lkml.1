Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYKZCdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYKZCdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYKZCdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:33:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:29864 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYKZCdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:33:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=WXN1LX7Jqy4txtNCyYeuHXCd9hd2MgkuygNsVumglP/teL8BKz8CMQH5DJD0XvtKNm
         rFgRuY7j7Ds9RYjZGSBaa2s9DgOffESHbr4BhQHCaCx1FfMrFoTleiN5gLct1Ef64tsA
         KEBraOtrYUONTjLSaKeX2MByGrGMqWkTb08zs=
Message-ID: <e38d12ff0811251833j6bcddech421fa240dd3f3302@mail.gmail.com>
Date: Tue, 25 Nov 2008 21:33:09 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: uvesafb has mode switch when switching between virtual consoles
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently using uvesafb as my framebuffer.
When I switch between virtual consoles (Alt+F{1,8}), there is a short
blank due to mode switching. The VC switch was instantaneous when I
used vesafb for my framebuffer.
Any reasons why?

-- 
Andrey Vul
