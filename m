Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbYEGRkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbYEGRkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYEGRka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:40:30 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:18993 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYEGRk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=G8Ugqiss2S4ffLgqCoGqCoB1qULgtEon3XPbexpLolvKeOLkgw+yUiH4CfuPpe6JwjuGkBpp+m4qzHlHJezakKhvxOOQp4tZ1Z2NFC6ALTYsGYXpM0qhQngQRonYbGIRM6RQiw6W+Lsy0IDm4MGcqDYNqzJnW6S0ELkiL180J1A=
Message-ID: <dd18b0c30805071040i5e9c3d73uf60235b94dcce3c5@mail.gmail.com>
Date: Wed, 7 May 2008 17:40:27 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: nopage to fault
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I'm trying to compile a module and am a bit confused with what
I should do. The module is using nopage, but since nopage was
converted to fault,
I have no choice but to see if the module will compile with fault. One
of the areas that I'm lost with is NOPAGE_SIGBUS for a return value.
in mm.h The only options I see is VM_FAULT_SIGBUS, VM_FAULT_ERROR. If
anybody has a advice it would be really appreciated.
regards;

-- 
Justin P. Mattock
