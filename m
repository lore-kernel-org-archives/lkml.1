Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbYESQEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbYESQEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYESQEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:04:20 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:7555 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYESQET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FIg8BsYY98dMGMeQ7NjlR3szbroT5H1wHXenYCEqY4kbujaGLzVHynAs/Bkyl/vnaLUD6e18kjkw0ANrl7lI53m8d8yfIoeLHLV7fQ+W68B3V1/QobJ0g2mDuYh32gB506MIODebBLxPgDl+F5WsWDNVn0SWCfDnbXnW9yNDWQc=
Message-ID: <438397970805190904i2656337dh26a3257fe52aa29d@mail.gmail.com>
Date: Mon, 19 May 2008 09:04:15 -0700
From: "Kallol Biswas" <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: HDMI Audio Support in ALSA
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   We are building a HDMI capture card that has a HDMI audio device.

The audio device needs to be integrated with ALSA framework.
Unfortunately the audio is not supported in ALSA.

I understand that work is being done at this moment to support the audio format.

Any information on when the support will be available is helpful.

Kallol

Senior Software Engineer
NucleoDyne System, Inc.
19925 Stevens Creek Blvd
Cupertino, CA 95014
