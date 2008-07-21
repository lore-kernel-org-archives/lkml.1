Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYGUVdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYGUVdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYGUVc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:32:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:51455 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYGUVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=phTNuvNk1ocXx5kfE61MuQjdCcHooD2g1XGBv6StUYgj8f8iMyU9jHYlT0FY287mC1
         9AXty4w254BvEjxoBn734G2Hfzcu/NchUobrhY0ixFsZy1DrlBqOLKUiJ2fyW9L2diOX
         x1Np0DPYLQ+hGW4nKEHe2n5vt+3hWUhVJ6pq0=
Message-ID: <dd18b0c30807211432g447e8f6fvb4b178134a203684@mail.gmail.com>
Date: Mon, 21 Jul 2008 14:32:55 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: mmconfig issue
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello;
apologize for the confusion.
and thanks for the help.
It seems I was missing a grub module
for doing a static kernel compile.
initrd grub module is there and works.
As for mmconfig I'll try the latest kernel in a few and see
if it works or not.
regards;
-- 
Justin P. Mattock
