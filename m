Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYJ2Rmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYJ2Rmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 13:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYJ2Rmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 13:42:45 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:49691 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYJ2Rmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 13:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=N+86BFwrA2OiMbqwTOVAOufEc8TL/zP63qZR3DyBaoV1UJc7ns9cUe50enbcT4x0V/
         +bDIrU/I1YyOq4jBnY8e1dtCVsgfj4WGrcnh92WsV0zLd98N1Q8dEDHjTZE7zmbNd+Xj
         GrK64lKDskhXSFfOluHG2TjHEPhG5M6KJAkEc=
From: Andrey Batyiev <batyiev@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: device_add_attributes
Date: Wed, 29 Oct 2008 19:43:02 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810291943.02772.batyiev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone

I'm trying to add many attributes to device. However, device_add_attributes 
doesn't exported. Is it better to use my own adding loop or export 
device_add_attributes?


Thanks,
   Andrey
