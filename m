Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYLAWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYLAWu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYLAWuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:50:19 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:51426 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYLAWuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:50:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=jIL0JOcc2ZvTQKD3k/RueXZwtD6LHbF+mcvTy2/5LKY49n8kAdYiUxahgzAgBJRhbV
         eDBlCWP6FMv+1rdgeVgI6cWQFLUNhFlNN70ILKaK834kX8PKXQezG2FPUnRgmqeCVCE5
         89F7NWqFsS6/ZJzZl4VwnHxC4iT2uabcvOR40=
Message-ID: <43e72e890812011450r2320b685m3fc9e776b7c27e5@mail.gmail.com>
Date: Mon, 1 Dec 2008 14:50:16 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [ANN] CRDA v0.9.5 released -- minor build enhancements
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a shiny new CRDA release, some general build enhancements and fixes the
build for use with openssl. These all come from Diego.

http://wireless.kernel.org/download/crda/crda-0.9.5.tar.bz2

  Luis
