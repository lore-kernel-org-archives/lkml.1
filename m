Return-Path: <linux-kernel-owner+w=401wt.eu-S936561AbZDCUvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936561AbZDCUvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbZDCUvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:51:04 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:43754 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887AbZDCUvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VFYXEesabCR+/GsusWZzwtCpe18nUAbCGvHAEf8V+ntITGS5Lj2qsVFqN4CekM6LJG
         e7w3+r+SMaO8EGQYCJvPxjOvmogA6RnYF4cSw7PnVhWtQfwk75lJVP1cnvLpbajMA5gT
         RMNk5e/rm9HngGD2vzJgL40F8WBdkNnIQGj4E=
MIME-Version: 1.0
Date: Fri, 3 Apr 2009 13:50:57 -0700
Message-ID: <dd18b0c30904031350x4773e25anf7921b2e55f5e2b5@mail.gmail.com>
Subject: black screen with 2.6.29 on new imac
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to find out if somebody else is having
the same issues as me(with the new imac):
latest kernel(2.6.29) loads up without any freezes.
upon startx I receive the lovely nvidia logo,
then nothing. (black screen)

xserver(version)
pulled from git yesterday.


As a simple test running ubuntu intrepid
(alpha version) loads fine with the xf86-nv
as well as the binary. but runs kernel 2.6.27-rc*
(leading me to believe that this has something to
do with 2.6.29; but could be wrong)

any ideas?

-- 
Justin P. Mattock
