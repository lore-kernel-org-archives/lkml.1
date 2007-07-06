Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbXGFGV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbXGFGV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 02:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbXGFGVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 02:21:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:44254 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbXGFGVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 02:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KJW2P3xprY6c1oBExmZISMJDn7DkdQwWotj1D+X+kmrGs4TnTSL78+HLZ8w6nKWUaPfp9/mPCv7i/9fMAJ5P23GZLzlrWFuQ61vTg57zqCAjClH2kI7nNrAmQw5EvW2GEMg7YBkEL1x8MG2O+qC0SwlkUuoZLlduRS1eWvTbT9o=
Message-ID: <7dce480a0707052321nacc0f10x2e20171760b97705@mail.gmail.com>
Date: Fri, 6 Jul 2007 06:21:16 +0000
From: "Kaleem Khan" <linuxuser8@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kill -9?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel experts,

I'd like to know whether there's a way to take some action (say
calling a routine) in
response to 'kill -9' before the process is terminated. I tend to
think it's against 'kill -9'
UNIX/Linux philosophy but still I'd like to confirm.

Thank you.
