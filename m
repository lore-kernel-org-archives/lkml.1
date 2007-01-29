Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXA2JCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXA2JCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 04:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933280AbXA2JCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 04:02:21 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:63890 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277AbXA2JCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 04:02:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JAX/YkDQRQgJmPJrrAfNIbq2zTeqCpLqfz0HVmczek5Flteod1A4m4fcU2wzuk4fP5WbLJGpIt3edJsPbsIFHJnYyMfugDw64CjMDLbeamWt1KDSQCTuFFFh5aY3kFclaTqytWdDNfeGcM1i4LzAAjDhm/PbcpradNOI3xqdIss=
Message-ID: <f36b08ee0701290102kd5c4ab1hef861cb3de9f042d@mail.gmail.com>
Date: Mon, 29 Jan 2007 11:02:19 +0200
From: "Yakov Lerner" <iler.ml@gmail.com>
To: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: software read-only flag for rw partition or disk ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does /proc have any entries to flip the "software read-only flag"
for a partition or disk (which are physically read-write) ?
Yakov
