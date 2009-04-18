Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZDRIds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZDRIds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZDRIdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:33:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:35042 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZDRIdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=p46eysmKPlQi3RbRmN4jzY+ztUqVJ9eFZja4jd7JX+3dOS0vibFtYaxx738ZuIz/mb
         0xirL7fQ94unRSP8hdnqKIIhEG5s3MHqRgE1W3MdmDSSpoPxttLESFuq5sjw9Zcb/Qpq
         heG07zumJzed0NRKCGwSiHmXoduGT6gWE87Rs=
Subject: uvcvideo: unknown event type 206.
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 18 Apr 2009 01:33:46 -0700
Message-Id: <1240043626.12779.12.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using mplayer to test isight Im getting
a long line of spew-edge:
(i.g. mplayer tv:// -vf mirror)


 [39906.998002] uvcvideo: unknown event type 0.
[39907.054105] uvcvideo: unknown event type 0.
[39907.194102] uvcvideo: unknown event type 236.
[39907.262102] uvcvideo: unknown event type 119.
[39907.330197] uvcvideo: unknown event type 206.
[39907.397981] uvcvideo: unknown event type 206.
[39907.466102] uvcvideo: unknown event type 206.
[39907.530109] uvcvideo: unknown event type 206.
[39907.597981] uvcvideo: unknown event type 206.
[39907.666103] uvcvideo: unknown event type 206.
[39907.734116] uvcvideo: unknown event type 206.
[39907.802106] uvcvideo: unknown event type 206.
[39907.870196] uvcvideo: unknown event type 206.
[39907.937995] uvcvideo: unknown event type 206.
[39908.006120] uvcvideo: unknown event type 206.
[39908.070200] uvcvideo: unknown event type 206.
[39908.137981] uvcvideo: unknown event type 206.
[39908.206111] uvcvideo: unknown event type 206.
[39908.274102] uvcvideo: unknown event type 206.
[39908.342105] uvcvideo: unknown event type 206.
[39908.410197] uvcvideo: unknown event type 206.
[39908.477981] uvcvideo: unknown event type 206.
[39908.542105] uvcvideo: unknown event type 206.
[39908.610215] uvcvideo: unknown event type 206.
[39908.677982] uvcvideo: unknown event type 206.
[39908.746102] uvcvideo: unknown event type 206.
[39908.814096] uvcvideo: unknown event type 206.

continues with "type 206" until I hit ctrl C".
(as for images etc.. fine.. 
you would never expect anything wrong, just spam from dmesg);

regards;

Justin P. Mattock


