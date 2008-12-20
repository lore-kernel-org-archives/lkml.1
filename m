Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYLTKu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYLTKu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 05:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYLTKut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 05:50:49 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:4276 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbYLTKus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 05:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:cc:content-disposition:from:date:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=jkT07l2cVaSYsR//RAs1BSv+clNKJhQr3qm8wuhQpjNpivv82StA0AblL8fjBNTZDP
         EJeGIXY+73kGXCTS3M7dSXDXvn7RTFbI9q+aGKMPqr+Y4Jrz7PtntsHlCbNutIa1/kk0
         nNBxe6pygEvaJBnNmStlCwvaVfbTABrDeHh4g=
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH 13/33] Input: Make static
Cc: linux-input@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Sat, 20 Dec 2008 02:50:27 -0800
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200812200250.28014.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2008 10:44:41 Roel Kluin wrote:
> Sparse asked whether these could be static.
>

Applied to 'next' branch, thank you Roel.

-- 
Dmitry

