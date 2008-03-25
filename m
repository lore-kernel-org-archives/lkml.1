Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYCYKXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYCYKXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYCYKXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:23:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:53398 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYCYKXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=G6Qni4SpZ6EKs/pz+ahsVoP3s7+4hSbCdS3kYivW3+r5Cbzscqvmb02ismd3HAL1kjO64HdA/f863OmLMKBlH0mrZRCXA3onAI5ouciDtPWXNf8RNpoX9lSTGrW9eZoY+puXMdwHTZZUBosCbwFC2PU2TQFupqIX8qbbocCOv6M=
Message-ID: <983191750803250323k2e944fe0y53e4c0d69edde3b@mail.gmail.com>
Date: Tue, 25 Mar 2008 15:53:36 +0530
From: "Shard Gupta" <shard.kgp@gmail.com>
To: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Subject: Allocating memory in the form of 'BITS'
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

I am writing a linux kernel module, and I want to allocates the memory
in a way so I can define each individual bit, like bitfield structure
in userspace.
Please tell me the way to do the same.

Thanks and regards,

Shard Gupta
