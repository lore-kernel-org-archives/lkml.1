Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZD3T4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZD3T4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZD3T43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:56:29 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:39437 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZD3T42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xYX0EK4d1U08xwVt+HyJeEF35mSDDMZzHCXUiMQj7hkR9RG42DjAgkoI6GgnRKo22t
         XsipKQXO8jPbbvOtVc/Daqg5AnHWTVElqTWbkvXGmaspeFzxAAynAK6c7nvyAXUL4Wil
         08ERiv8mSwIJCSxm5L3U1Mwo/14tgiMNMAfaQ=
MIME-Version: 1.0
Date: Thu, 30 Apr 2009 12:56:28 -0700
Message-ID: <dd18b0c30904301256h501725f9v2da376759dc04b32@mail.gmail.com>
Subject: sys.log spammed with uvcvideo: unknown event type 110.
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-uvc-devel@lists.berlios.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello I'm trying to do some webcam
testing, but seem to be having a difficult time
reading dmesg due to uvcvideo spamming
dmesg with:


Apr 30 12:40:11 unix klogd: [ 9619.151420] uvcvideo: unknown event type 0.
Apr 30 12:40:11 unix klogd: [ 9619.207427] uvcvideo: unknown event type 23.
Apr 30 12:40:11 unix klogd: [ 9619.343364] uvcvideo: unknown event type 16.
Apr 30 12:40:11 unix klogd: [ 9619.471441] uvcvideo: unknown event type 59.
Apr 30 12:40:11 unix klogd: [ 9619.647442] uvcvideo: unknown event type 110.
Apr 30 12:40:11 unix klogd: [ 9619.775439] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9619.843295] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9619.911428] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9619.979437] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9620.047421] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9620.115439] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9620.183314] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9620.247423] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9620.315407] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9620.383305] uvcvideo: unknown event type 110.
Apr 30 12:40:12 unix klogd: [ 9620.451440] uvcvideo: unknown event type 110.


is there a way I can take this message out, as a quick workaround
so I can read the rest of dmesg, and sys.log?

-- 
Justin P. Mattock
