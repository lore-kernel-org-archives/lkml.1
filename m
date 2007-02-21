Return-Path: <linux-kernel-owner+w=401wt.eu-S1423205AbXBUW16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423205AbXBUW16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423206AbXBUW16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:27:58 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:42273 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423205AbXBUW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:27:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RJWbGKpMr2QpVysHXc/DPanMghirAsg2m4EK9lonmxana+N30qutC5O6gtW7GQB4N+7+xosGmR3ApzkRrUVpLw8+q3/W1W2lGZQGxpOtxkRpwskvmzKhxTFnVFWO7wwv+pytyzVdEGXAA8p+vetVemb7J/7uIW6NMwf4i0SxWI4=
Message-ID: <d120d5000702211427y423acfdekb83343a4f90caab0@mail.gmail.com>
Date: Wed, 21 Feb 2007 17:27:56 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: CIJOML <cijoml@volny.cz>
Subject: Re: Re: Phis in /proc/bus/input/devices same for all devices?
Cc: linux-kernel@vger.kernel.org, "Marcel Holtmann" <marcel@holtmann.org>
In-Reply-To: <200702212313.30359.cijoml@volny.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702212313.30359.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, CIJOML <cijoml@volny.cz> wrote:
> Hi,
>
> can anybody reply to this and share his/her opinion?

Input core already exports uniq to udev and also via sysfs.

-- 
Dmitry
