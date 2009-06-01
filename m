Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbZFAFxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbZFAFxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZFAFxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:53:42 -0400
Received: from mail-qy0-f130.google.com ([209.85.221.130]:61523 "EHLO
	mail-qy0-f130.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZFAFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=aGL8itT3x8PSr4sitXdk3grS24zdZ4md35Ogno7dKENMDGnIBFClQD4qIFolb8KsQV
         Q7WyteisBSRqwc8VZrWLWSYJjdbU0LAYs8Kn42Wt+vRW8a5sIcYEOmfll6aib7tlDzai
         lL59cgnkJwvQVIjbnWt08NDr9UByaymjuPB+Q=
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 11:23:42 +0530
Message-ID: <f24b07420905312253pbf64c7k6a60a01dc1f77a71@mail.gmail.com>
Subject: /proc/kcore support for the ARM
From: Bhavesh Parekh <bhaveshparekh1@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I wanted the /proc/kcore support for the ARM for the kernel 2.6.22. I
am aware that people are not very much interested in adding this
support, but I required this support for our platform
Does any one has the patch for it ? or can give instruction for
enabling this support in the ARM. I won't mind if adding this support
break the build for other platform.

-Thanks
Bhavesh
