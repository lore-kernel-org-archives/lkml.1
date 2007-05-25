Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbXEYO0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbXEYO0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 10:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXEYO01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 10:26:27 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:38891 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXEYO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 10:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VuPA/zEvm8oAMJ8j96fWJmA8Q0wPzieYK8kKLAqFuJvA8vfRVZd2KYd6POL5r1RygHhQTrNGaSEnd90yUlfN00NKtyTEQa0vqyES1ryrCSzpJkZSHn2SN0fXU/uG6spdG9S7Gh7KvYzlA1m90Olh2DXFSPJfMlBeWuIb9rtkQB0=
Message-ID: <2bd9ebfa0705250726t64b017f3sf36ab95c36089bde@mail.gmail.com>
Date: Fri, 25 May 2007 10:26:24 -0400
From: "Tej Parkash" <tejparkash.d@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH - 1/1] Reg: __builtin_expect(!!(x), 0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

what is this hack and why it is required
