Return-Path: <linux-kernel-owner+w=401wt.eu-S936690AbXGZUPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936690AbXGZUPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932275AbXGZUPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:15:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:62652 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbXGZUPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TjKSW2m0MYlqa9FVB6HI5Fw7mO9qtVTNX6MKEOGRyX38fTUz0T81AmpZyM26KdAbpDJBSm7TfXe2EMocufQeI3JtVqtWJ7FtiQtfrpdiSJjdOIcL7cBO+rkOoq8Njo3BR6IchRH9g6x29UFWkLM1RMOWmiUkJo1nsGN3NFgRK8o=
Message-ID: <86802c440707261315m2c25fdek31307674a49bce81@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:15:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH 00/05] x86_64 apicid_to_node cleanup
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

please check the clean up for x86_64 apicid_to_node.

Thanks

Yinghai Lu
