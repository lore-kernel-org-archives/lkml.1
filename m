Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbXBWPSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbXBWPSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932615AbXBWPSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:18:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:8939 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbXBWPSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:18:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cWMgSWQlB1A/r4m0T9HEbGivZWAfYERJ8Onm194YRpagyaZXHMG+erhM46H8XDRLf6EVNDqDXilA8+ykvolSdKJ0Fczi8hFAzEhPYVwKOAMd5vdg6Li9ZKBtdTsHkE3wJ64Tm20iMu35HJkF5LsMn4oDmwU8HV5Lav6lrotA8+I=
Message-ID: <a02278b00702230718i74df1d63g954bd7ac83298696@mail.gmail.com>
Date: Fri, 23 Feb 2007 07:18:13 -0800
From: "Allexio Ju" <allexio.ju@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: trivial question regarding byte ordering
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a API (or macro) that checks CPU endianness and does byte
ordering conversion on given data (32-bit) if endianness is
big-endian?

Thank you in advance for your comment.

Regards,

Allexio
