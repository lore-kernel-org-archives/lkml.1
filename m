Return-Path: <linux-kernel-owner+w=401wt.eu-S1030742AbXAZEg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030742AbXAZEg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 23:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030743AbXAZEg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 23:36:28 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:53260 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030742AbXAZEg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 23:36:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EtVeh+AmMyOSCIJdrNAgAh0IYhsCgd1MBJBmQfXAhS0xtGHvqVayhSnZthcqO5PT9wmkPsEMXGkEzxZ7auVTwT9G+AKikbwA20tu2Q2Bw7Hk1oESOMsUoNRvx4/KhlCqX1ZIR4Bldzfc5d1CzHkjooIGGpPI5WBEYk2M6IDzvUs=
Message-ID: <526ad3230701252036q197272eaha17cece3a5df93dc@mail.gmail.com>
Date: Thu, 25 Jan 2007 20:36:22 -0800
From: "Siddharth Taneja" <siddharth.taneja@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6 I/O schedulers per thread?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Are the I/O scheduler queues in the 2.6 kernel (particularly for CFQ)
maintained per thread or per process? If it is per process is there a future
plan in place to make them per thread.

Thanks a lot.

Siddharth
