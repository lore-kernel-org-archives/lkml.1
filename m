Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYJPG45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYJPG45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYJPG4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:56:49 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:46302 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYJPG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZvzEZhBw5TM0j9F+8bOV7tPosbbI3bRsxci1EF+Ip/JkWoOaW5hxBEQ3kkfgki6r4d
         bdcwmg3W7dFXy2oyjd5jW/FtP9tbzshNYPBwIoaaTIEOevN+7v/Z9QJWISherF/dHIRi
         7dsG1zcUHRa4nr3MthzCvOJxGKIGGdgTUd40s=
Message-ID: <241b8f7b0810152356o62bd86eclfa4e0027e41ca563@mail.gmail.com>
Date: Thu, 16 Oct 2008 12:26:46 +0530
From: "Prabhu Chawandi" <prabhu.chavandi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CONFIG Symbol
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

  I have added a symobol in thr config file, freshely ... eg.
CONFIG_USB_SERIAL_CONSOLE

i.e. there was no symbol at all ... but in the source code a check is
made for that symbol...

 So I have added that symbol in the config file,,,
unfortunately I am not getting that  flag value reflected,,,,


What I thought ,, Is there any other place where to identify this symbol...

as we export any symbol...

-- Thanks
Prabhu
