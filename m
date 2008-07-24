Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYGXRQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYGXRQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYGXRQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:16:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:64518 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYGXRQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:16:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:subject:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rzR6AFGFkN/+Gfi2D57tuj/W32FkdX8A54D/aqA+WGQCHvbGxh0Oe0mBNp8UCrrhTr
         gQnOzRJmWxB+fqwFwrkcAb6SWa9RZEiDge1XDOGz3vGdOXRnkku0/DxOspVAkuLs6U6V
         O7RomeCAFQpcvi8RRrMoXxRgLJFzjulmnFnn4=
Message-ID: <4888B8CD.1030501@gmail.com>
Date: Thu, 24 Jul 2008 19:15:57 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080618)
MIME-Version: 1.0
To: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: 2.6.26 vanilla paravirt config issue
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

on my amd64 profile i cannot disable PARAVIRT option.

even if i disable all i still get in my .config:

# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_VSMP=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_PARAVIRT=y    <<<<-------------------------------- issue
# CONFIG_MEMTEST_BOOTPARAM is not set
# CONFIG_M386 is not set

how to disable it? i guess it's a config bug.

CC me i'm not subscribed.

---
Patrizio Bassi

www.patriziobassi.it
