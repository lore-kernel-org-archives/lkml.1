Return-Path: <linux-kernel-owner+w=401wt.eu-S1761115AbYDCVwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761115AbYDCVwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760959AbYDCVu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:50:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:59171 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760895AbYDCVuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Hxn4/GrVeeCJrll5Pr0LYtfrtMfRw2NtySvk7ZQXKIe9zFuc+dIQsL2fJsRzY2X34dDhhwNtW/ukqp8dgu6PkQZB5cp0UKaM2dJgm2pLfrkg5MDbXt5Rm0mV3y5ltim4uvF7L8oQCyIVUpMhhQGLIH8drfjD5U5cOfiS3hY2Lgk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: [PATCH 2/2] ide: remove now unused ide_pci_create_host_proc()
Date: Fri, 4 Apr 2008 00:04:57 +0200
User-Agent: KMail/1.9.9
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
References: <200804022045.54361.adobriyan@sw.ru>
In-Reply-To: <200804022045.54361.adobriyan@sw.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804040004.57726.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Alexey Dobriyan wrote:
> It creates files in proc with obsoleted ->get_info interface.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>

applied
