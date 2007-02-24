Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXBXJ4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXBXJ4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 04:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933470AbXBXJ4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 04:56:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:30782 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbXBXJ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 04:56:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aEMDJTQDjWbDJ6ZmqOfLjv2gcqVDUD3Bm3yT66VGeEmPG4doS0I+Vu9oLlcuDyWqFezMQwkiN7bcPAJPd+bOzkF5FiSZ+2un5LHGbJ8wLA5gWgKiULTBd9kG2QO32WU9TQwprooi+aQ4hUBvYdi37CmWxprqB3gylmpVQP1KaGA=
Message-ID: <c9ad85600702240156g717d49cfm9c7ea30c00d48d28@mail.gmail.com>
Date: Sat, 24 Feb 2007 03:56:34 -0600
From: "V P" <upathiyayan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: REQ_HARDBARRIER and REQ_SOFTBARRIER
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to modify the ordering of I/O requests in Linux kernel, and
came across the barrier flags REQ_HARDBARRIER and REQ_SOFTBARRIER.

One thing I noticed (which might be wrong) is that all the requests
have both these flags set. What is the significance of these flags? Is
it a must for a request to have this? Can I reorder two requests with
these flags set? How is SOFTBARRIER different from HARDBARRIER?

I appreciate your time and help.

Thanks much.
