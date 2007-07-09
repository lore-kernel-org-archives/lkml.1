Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbXGISzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbXGISzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759001AbXGISzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:55:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:26810 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbXGISzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=E1aJ+h6o0h/E/Z91urHGiMSyBTMlMjYDtSsg8uVxXhw77Omv81ff16035+e8QZBG6np+2RJf3a7c2mat+IPqQ6lkznGF4ixRZIstTXr0EC4YL0wRlzDhU1W99Dpjo7dtEvRiaHv5/eKwwvadRj/hyE6Mg20b9JW3ZOElaww4d+M=
Message-ID: <f8b2ccd40707091155g23bea086o194203f0df6df3e8@mail.gmail.com>
Date: Mon, 9 Jul 2007 11:55:21 -0700
From: "Gautam Singaraju" <gautam.singaraju@gmail.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: BigNum support in Kernel?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I am planning to work on some experimental crypto support in kernel
level. For the development, I need to use BigNum library. I wanted to
load a minimal BigNum library into memory for high performance. Any
suggestions on what library would be the best?

---
Gautam
