Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXEDIc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXEDIc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932812AbXEDIc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:32:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:34004 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbXEDIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=T1AWzHEYH25Xr7vEG9BRI1At+yf0nrmiMKXlDVSP0S/uoyeIu8onvtpgFUfULsqCdsjVRZiTdG27raC87gnyCLd3++wLm72IU/ZZca6YXTcPa4JQVEktN2Bze2yDRUGw7UdsSQC7xb0gTgpC7aq0VZURUFNy12jyzm3u4nVyxk8=
Message-ID: <99e4df080705040132m41116db3y50c73c79528d6206@mail.gmail.com>
Date: Fri, 4 May 2007 16:32:27 +0800
From: "la deng" <ladeng.mimi@gmail.com>
To: torvalds@linux-foundation.org
Subject: c 's OOP in VFS vs c++'s OOP
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

reference to the c++'s father's interview

http://www.artima.com/intv/abstreffi.html

 fortran and c++ can  achive good performance for they can abstract in
higher level and  their compiler can think in higher level to avoid
the cache miss (like in the array vs vector )or to achive the "no
code" Optimization

The vfs using c to OOP but c compiler can't have the high level
Intelligence as the c++ or fortran's compiler to help at the high
level Optimization


one benchmark showed the c insert in the array will slow by speed of   1/17


Then ,what's the power of c OOP vs c++ with the compiler's
Intelligence in OOP?or maybe the c compiler have Outdated？

any input will be appreciated.
