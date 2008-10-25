Return-Path: <linux-kernel-owner+w=401wt.eu-S1751634AbYJYVP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbYJYVP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYJYVPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:15:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:21806 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYJYVPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BAUUsu6pfGNO683asEVH+mtecw182i2p/Qw0n7/KGnmZRFV3DFyi+tlGLdJADuKWO5
         CALweIQkrQXUA+gWCs50s1Yqk3YWhQRb6wEdOQOxfcOwtFMtP+BGs/uIBSR3llZmY0/i
         yg52PuQA+rd3TfYhUzTkFf6F+8ZS3dmpNkcns=
Message-ID: <49038C5C.7000708@gmail.com>
Date: Sat, 25 Oct 2008 23:15:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.28-rc1 regression] appletouch
References: <1224966797.5303.3.camel@localhost>
In-Reply-To: <1224966797.5303.3.camel@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2008 10:33 PM, Soeren Sonnenburg wrote:
> Dear all,
> 
> I've noticed that the mouse does no longer work in X using 2.6.28-rc1
> nor does the fn-key emulation work on my macbookpro 1,1.
> 
> It perfectly works with 2.6.27.3...

Please follow
http://bugzilla.kernel.org/show_bug.cgi?id=11825
