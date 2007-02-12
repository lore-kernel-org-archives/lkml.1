Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbXBLH1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbXBLH1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933065AbXBLH1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:27:10 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:49194 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062AbXBLH1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kn/YLaFRa2c2P5eCJeuKym04ffu4UwSTV8yi4DOsZ3pajtt4+cKlOCXZmaorpgnvl8aihxccVsbmhRG5DROxE8RpZG9TBvgU/MwQHcgxEERYMM5K9Wa109QGI1m6s5V9wUQZYCZxhmB2LlG//GUZAMN+N6oDxYumCNfCUVe8510=
Message-ID: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com>
Date: Mon, 12 Feb 2007 15:27:08 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [QUESTION] file access time in millisecond?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible to get file access time in millisecond resolution?

stat() returns time in seconds, but gettimeofday() can returns microseconds.


Thanks,
Jeff.
