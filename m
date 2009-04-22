Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZDVOsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZDVOsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZDVOsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:48:37 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48212 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZDVOsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N8omERE9eCMzNG9fXmVQkHr7mi9/p0kgopQb0IOOaWmL0MwRgf/+jqI9u+kQ27v1GS
         VDQzdyhmy4eioJs9OYeojD6cTTPXGV95Mb0f/pJ+Ls/bQhP+ozYSvCvacINAa8o/xmLo
         IrYPCIL6tGQy6HA0zSTKYSDaVBUMBIp1LrwIM=
MIME-Version: 1.0
In-Reply-To: <871vrkpyae.fsf@basil.nowhere.org>
References: <f44001920904220712ye1644c9y90d637bf4ac3bbe@mail.gmail.com>
	 <871vrkpyae.fsf@basil.nowhere.org>
Date: Wed, 22 Apr 2009 18:48:34 +0400
Message-ID: <f44001920904220748j228ff478ha32024ff873544c5@mail.gmail.com>
Subject: Re: Idea: Feature information / extensions dispatcher syscall.
From: Igor Zhbanov <izh1979@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it bad that modules will dynamically register/unregister their syscalls
and libraries will ask numbers via standardized interface?
