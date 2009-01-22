Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZAVHmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZAVHmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 02:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZAVHm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 02:42:29 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:26038 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZAVHm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 02:42:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=R6RAsI2qSSSpIOgQNaz98V6M06RbxEwFUcCSxjJ+xh1JyivoePvYhnUkgLJmyWNYPN
         LgB1ReUiQzfLSIFS5KvEU6Ew5v8xts73GkGS5ZAGMCE5vKWnyxa/Y/S3j+5Rb9H/J4EU
         18B1IU/vXKoQa6nRJeFGZ8Q/sVUXyOav73c2s=
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 08:42:28 +0100
Message-ID: <b0438a630901212342o543ed522p60376f764b6248b5@mail.gmail.com>
Subject: IXP4XX queues
From: =?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?= <gotzoncabanes@gmail.com>
To: Karl Hiramoto <karl@hiramoto.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Last December we talked about 64 queues and IXP4XX. Karl has a patch
for them, and although I think it could be better to splitt it into
two different ones ("plain 64 queue expansion" for which I proposed a
modified patch based on Karl's, and "debugging and other things"), I
prefer Karl's to none.

What do you think of this? Which should be the best way to include it
in the main stream kernel?

Thanks

Miguel Ángel
