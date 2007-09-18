Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbXIRMh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbXIRMh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 08:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbXIRMhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 08:37:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:40047 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbXIRMhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 08:37:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=phDsEUQsKbmma6oy81qeyydYdKzBFiuCqxG8mENJwDTwdHZTyAuaICq4lBUFPWNuBi34FBSp8g0kqRkkEiZHmdQAHvv17XPK/gIPSi2emM8PH5k1aSmxiHQLvlFZVpisPZWR73V0CcFV3jPrt+lilgNzBtuJPFUzQbVBPBPTm+Q=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: alternatives in modules
Date: Tue, 18 Sep 2007 13:36:59 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709181337.00089.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

I was looking through kernel/module.c and if understand it
correctly, it doesn't handle .altinstructions in modules at all.
Am I reading code correctly?
--
vda
