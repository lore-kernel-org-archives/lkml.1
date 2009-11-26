Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbZKZJZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbZKZJZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760141AbZKZJZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:25:33 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:58744 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071AbZKZJZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gl0dbArj6j2xI23IR7SjiIzcf8YrvqoS9POF6ZZZhPyujJuI71eYyt4r20oDJqGsyr
         h0LVhOBsUTx+VmtXPcLYP+zOiSdM/yu0HJKpXWlfTZHzCFcUg3LZiBu2DlydahuFDZpr
         zzGjxOQWZS6RiyA+wehhylxTGiBTYCGDC3Rhg=
MIME-Version: 1.0
Date: Thu, 26 Nov 2009 18:25:38 +0900
Message-ID: <90b950fc0911260125s39c86aees5b76f28af47f7a8f@mail.gmail.com>
Subject: What is the purpose of w1 driver(/driver/w1).
From: InKi Dae <daeinki@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to implement backlight driver that it uses single-wired
interface based on gpio.
for this, I found single-wired interface driver in /driver/w1

is it the driver for network protocol using single-wired interface?
otherwise could it be used commonly like backlight device ?

Thank you.
