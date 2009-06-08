Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZFHF4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZFHF4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 01:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZFHF4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 01:56:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:9921 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZFHF4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 01:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=FHfm92MM7uoD0l0RnEK+nNb5DDValfMeoDG03iw9ulesshFyPZBQWT746mtMKEVobU
         9GyOLSgxNgtUl0jkw9TKxW5IYzx1gDhVo/bdDcFG+Li7mU/X7bVCHsZTJXezY6tt09je
         PkMjCFDUKhAgBCLRPji8sgoJ5mGIcF1PkPOV0=
MIME-Version: 1.0
Date: Mon, 8 Jun 2009 13:56:14 +0800
Message-ID: <6d6e77f50906072256m31c17ae8j5c4634ab5ad44761@mail.gmail.com>
Subject: Linux Bridge Module
From: eko suwarsono <ekoswr76@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I'm newbies on this mailing list, so please advise me if i asking the
wrong question.
I had plan to add bridge module (bridge.ko) on embedded system which i
got from vendor. the embedded linux system is using Debian sarge 1.3
and has linux kernel 2.6.20.4 with gcc 3.4.4. the operating system is
installed on CF card

i tried to compile the linux kernel 2.6.20.4 using gcc 3.4.4 on
another system which using ubuntu feisty to get the bridge.ko module.
and then copying the module into the embedded system.

the problem here that the insmod complaining : -1 invalid module format.

can somebody help me on this? many thanks for all
