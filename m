Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbYA3LyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbYA3LyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYA3LyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:54:01 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:9600 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYA3LyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SOnt1pGpzThPw46Pn7wYy5wYjEvi/jcqWdEG323t/icEp0EfoVuUStIaJoOHaXcJ6QWAlY/2tZKL3pv+7jvkY3dq9mVrXg7DGyl7P0x81tNLEzfdA/2j04IXZDGRX52T2YVnJAeN87vOtavdNqlUDmjpN7GJjjw3+mS13FK2mOw=
Message-ID: <87a5b0800801300353l196b39bekad6af6ccdbd49d5b@mail.gmail.com>
Date: Wed, 30 Jan 2008 11:53:59 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [PATCH 1/1] [INPUT] keypad driver: Added support for OpenCores Keyboard Controller
Cc: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, "Javier Herrero" <jherrero@hvsistemas.es>
In-Reply-To: <1201686610-31458-1-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201686610-31458-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 9:50 AM, Bryan Wu <bryan.wu@analog.com> wrote:

> +config KEYBOARD_OPENCORES
> +       tristate "OpenCores Keyboard Controller"
> +       help
> +         Say Y here if you want to use the OpenCores Keyboard Controller
> +         http://www.opencores.org/projects.cgi/web/keyboardcontroller/overview
> +
> +         To comile this driver as a module, choose M here. the
> +         module will be called opencores-kbd.
> +

Typo, "comile" should be "compile" here.
